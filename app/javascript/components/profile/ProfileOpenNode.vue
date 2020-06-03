<template>
  <div class="m-20">
    <div class="mb-16">
      <text-field font-size="full">
        Cargar a Bitsplit
      </text-field>
      <form
        @submit.prevent="handleChargeSubmit"
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
            :currency-options="currencyOptions"
          />
        </div>
        <submitButton :loading="chargeAllowed" class="my-1 flex items-center">
          <p>cargar</p>
        </submitButton>
      </form>
      <div v-show="showChargeInvoice" class="pt-4 flex flex-col md:flex-row">
        <text-field font-color="secondary">
          Paga el siguiente invoice y apenas recibamos la confirmación la
          cargamos a tu cuenta:
        </text-field>
        <p class="break-all">
          {{ chargeInvoice }}
        </p>
      </div>
    </div>
    <div>
      <text-field font-size="full">
        Retirar de Bitsplit
      </text-field>
      <InputLabel>
        Crea un invoice con el monto que quieras retirar y nosotros lo pagamos.
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
  </div>
</template>
<script>
import { mapActions } from 'vuex';

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
  },
  data() {
    return {
      currencyOptions: ['BTC'],
      amount: '',
      currency: 'BTC',
      invoice: '',
      loading: false,
      showChargeInvoice: false,
      chargeInvoice: null,
    };
  },
  computed: {
    chargeAllowed() {
      return this.loading || !(this.amount && this.currency);
    },
    withdrawalAllowed() {
      return this.loading || !this.invoice;
    },
  },
  methods: {
    ...mapActions('user', ['withdrawalOpenNode', 'chargeOpenNode']),
    handleChargeSubmit() {
      this.loading = true;
      const { amount, currency } = this;

      return this.chargeOpenNode({ amount, currency })
        .then(res => {
          this.setShowChargeInvoice(res.response.lightning_invoice.payreq);
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
    setShowChargeInvoice(invoice) {
      this.showChargeInvoice = true;
      this.chargeInvoice = invoice;
    },
  },
};
</script>
<style lang="scss"></style>
