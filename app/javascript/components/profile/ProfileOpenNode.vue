<template>
  <div class="m-20">
    <div class="mb-16">
      <text-field font-size="full">
        Cargar a Bitsplit
      </text-field>
      <spinner v-if="depositLoading" />

      <InputLabel>
        Elige un monto a cargar y nosotros crearemos un invoice para que pagues.
      </InputLabel>
      <form
        @submit.prevent="handleDepositSubmit"
        class="flex flex-col md:flex-row"
      >
        <div class="md:mr-2 my-1 flex-grow">
          <textInput
            field-id="amount"
            field-type="number"
            field-placeholder="0.2"
            field-name="amount"
            v-model="amount"
          />
        </div>
        <div class="md:mx-2 my-1">
          <select-input
            field-name="currency"
            field-id="currency"
            v-model="currency"
            :options="currencyOptions"
            :name-mappings="nameMappings"
          />
        </div>
        <submitButton :loading="depositAllowed" class="my-1 flex items-center">
          <p>cargar</p>
        </submitButton>
      </form>
      <div v-show="showDepositInvoice" class="pt-4 flex flex-col md:flex-row">
        <text-field font-color="secondary" class="text-left p-2">
          Paga el siguiente invoice y apenas recibamos la confirmación la
          cargamos a tu cuenta:
        </text-field>
        <p class="break-all text-left p-2">
          {{ depositInvoice }}
        </p>
        <qrcode-vue
          :value="depositInvoice ? depositInvoice : ''"
          size="200"
          level="L"
          class="self-center p-2"
        />
      </div>
      <submit-button
        width="full"
        v-show="showDirectDepositButton"
        @do-click="payInvoiceWithBuda()"
        :loading="depositLoading"
        :key="directDepositButtonKey"
      >
        ¡Pagar directamente desde tu cuenta Buda!
      </submit-button>
    </div>

    <div>
      <text-field font-size="full">
        Retirar de Bitsplit
      </text-field>
      <spinner v-if="withdrawalLoading" />
      <div>
        <InputLabel>
          Crea un invoice con el monto que quieras retirar y nosotros lo
          pagamos.
        </InputLabel>
        <form
          @submit.prevent="handleWithdrawalSubmit"
          class="flex flex-col md:flex-row"
        >
          <div class="md:mr-2 mb-2 flex-grow">
            <textInput
              field-id="invoice"
              field-type="text"
              field-placeholder="Ingresa el invoice aqui "
              field-name="invoice"
              v-model="invoice"
            />
          </div>
          <submitButton :loading="withdrawalAllowed">
            Retirar
          </submitButton>
        </form>
      </div>
      <div class="pt-4" v-if="budaSignedIn">
        <InputLabel>
          Retirar directamente a tu cuenta de Buda.
        </InputLabel>
        <form
          @submit.prevent="handleWithdrawalDirectSubmit"
          class="flex flex-col md:flex-row"
        >
          <div class="md:mr-2 mb-2 flex-grow">
            <textInput
              field-id="budaWithdrawalDirect"
              field-type="number"
              field-placeholder="0.12"
              field-name="budaWithdrawalDirect"
              v-model="budaWithdrawalDirect"
            />
          </div>
          <div class="mx-2">
            <select-input
              field-name="currency"
              field-id="currency"
              v-model="currency"
              :options="currencyOptions"
              :name-mappings="nameMappings"
            />
          </div>
          <submitButton :loading="directWithdrawallAllowed">
            Retirar
          </submitButton>
        </form>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions, mapState, mapGetters } from 'vuex';

import QrcodeVue from 'qrcode.vue';

import Spinner from '../Spinner';
import TextField from '../TextField';
import textInput from '../Input';
import SelectInput from '../Select';
import submitButton from '../SubmitButton';
import InputLabel from '../InputLabel';

export default {
  name: 'ProfileOpenNode',
  components: {
    TextField,
    textInput,
    submitButton,
    SelectInput,
    InputLabel,
    QrcodeVue,
    Spinner,
  },
  data() {
    return {
      currencyOptions: ['BTC'],
      nameMappings: { BTC: 'BTC' },
      amount: '',
      currency: 'BTC',
      invoice: '',
      budaWithdrawalDirect: '',
      depositLoading: false,
      withdrawalLoading: false,
      showDepositInvoice: false,
      depositInvoice: null,
      depositOrderId: null,
      showDirectDepositButton: false,
      directDepositButtonKey: 0,
    };
  },
  computed: {
    ...mapState('user', ['userBalanceBitsplitBTC', 'userBalanceBudaBTC']),
    ...mapGetters('user', ['budaSignedIn']),
    depositAllowed() {
      return this.depositLoading || !(this.amount && this.currency);
    },
    withdrawalAllowed() {
      return this.withdrawalLoading || !this.invoice;
    },
    directWithdrawallAllowed() {
      if (this.userBalanceBitsplitBTC < parseFloat(this.budaWithdrawalDirect)) {
        return true;
      }

      return this.withdrawalLoading || !this.budaWithdrawalDirect;
    },
  },
  methods: {
    ...mapActions('user', [
      'withdrawalOpenNode',
      'depositOpenNode',
      'budaDirectWithdrawal',
      'budaDirectInvoicePay',
    ]),
    setShowDepositInvoice(invoice, orderId) {
      this.showDepositInvoice = true;
      this.depositInvoice = invoice;
      this.depositOrderId = orderId;
      if (this.budaSignedIn && this.userBalanceBudaBTC >= this.amount) {
        this.showDirectDepositButton = true;
        this.directDepositButtonKey++;
      } else {
        this.showDirectDepositButton = false;
      }
    },
    handleDepositSubmit() {
      this.depositLoading = true;
      this.showDirectDepositButton = false;
      const { amount, currency } = this;

      return this.depositOpenNode({ amount, currency })
        .then(res => {
          this.setShowDepositInvoice(
            res.response.data.lightning_invoice.payreq,
            res.response.data.order_id
          );
          this.depositLoading = false;
        })
        .catch(() => {
          this.depositLoading = false;
        });
    },
    payInvoiceWithBuda() {
      const { depositInvoice, depositOrderId } = this;
      this.depositLoading = true;

      return this.budaDirectInvoicePay({
        invoice: depositInvoice,
        order_id: depositOrderId,
      })
        .then(() => {
          this.depositLoading = false;
        })
        .catch(() => {
          this.depositLoading = false;
        });
    },
    handleWithdrawalSubmit() {
      this.withdrawalLoading = true;

      const { invoice } = this;

      return this.withdrawalOpenNode({ invoice })
        .then(() => {
          this.withdrawalLoading = false;
        })
        .catch(() => {
          this.withdrawalLoading = false;
        });
    },
    handleWithdrawalDirectSubmit() {
      const { budaWithdrawalDirect } = this;
      this.withdrawalLoading = true;

      return this.budaDirectWithdrawal({ amount: budaWithdrawalDirect })
        .then(invoice =>
          // Bitsplit paga el invoice
          this.withdrawalOpenNode({ invoice })
        )
        .then(() => {
          this.withdrawalLoading = false;
        })
        .catch(() => {
          this.withdrawalLoading = false;
        });
    },
  },
};
</script>
<style lang="scss"></style>
