<template>
  <div class="m-20">
    <div class="mb-16">
      <text-field font-size="full">
        Cargar a Bitsplit
      </text-field>
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
    </div>
    <div>
      <text-field font-size="full">
        Retirar de Bitsplit
      </text-field>
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
  },
  data() {
    return {
      currencyOptions: ['BTC'],
      nameMappings: { BTC: 'BTC' },
      amount: '',
      currency: 'BTC',
      invoice: '',
      budaWithdrawalDirect: '',
      loading: false,
      showDepositInvoice: false,
      depositInvoice: null,
    };
  },
  computed: {
    ...mapState('user', ['userBalanceBitsplitBTC']),
    ...mapGetters('user', ['budaSignedIn']),
    depositAllowed() {
      return this.loading || !(this.amount && this.currency);
    },
    withdrawalAllowed() {
      return this.loading || !this.invoice;
    },
    directWithdrawallAllowed() {
      if (this.userBalanceBitsplitBTC < parseFloat(this.budaWithdrawalDirect)) {
        return true;
      }

      return this.loading || !this.budaWithdrawalDirect;
    },
  },
  methods: {
    ...mapActions('user', ['withdrawalOpenNode', 'depositOpenNode']),
    handleDepositSubmit() {
      this.loading = true;
      const { amount, currency } = this;

      return this.depositOpenNode({ amount, currency })
        .then(res => {
          this.setShowDepositInvoice(
            res.response.data.lightning_invoice.payreq
          );
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    handleWithdrawalSubmit() {
      this.loading = true;

      const { invoice } = this;

      return this.withdrawalOpenNode({ invoice })
        .then(() => {
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    handleWithdrawalDirectSubmit() {
      // this.loading = true;

      const { budaWithdrawalDirect } = this;
      console.log(budaWithdrawalDirect);

      // return this.withdrawalOpenNode({ invoice })
      //   .then(() => {
      //     this.loading = false;
      //   })
      //   .catch(() => {
      //     this.loading = false;
      //   });
    },
    setShowDepositInvoice(invoice) {
      this.showDepositInvoice = true;
      this.depositInvoice = invoice;
    },
  },
};
</script>
<style lang="scss"></style>
