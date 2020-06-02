// Todo
<template>
  <div class="m-8">
    <div class="p-2">
      <text-field font-size="full">
        Cargar a Bitsplit
      </text-field>
      <form @submit.prevent="handleChargeSubmit">
        <div>
          <textInput
            field-id="amount"
            field-type="number"
            field-placeholder="0.2"
            field-name="amount"
            v-model="amount"
          />
        </div>
        <div>
          <select-input
            field-name="currency"
            field-id="currency"
            v-model="currency"
            :currency-options="currencyOptions"
          />
        </div>
        <submitButton :loading="chargeAllowed">
          Cargar
        </submitButton>
      </form>
    </div>
    <div class="p-2">
      <text-field font-size="full">
        Retirar de Bitsplit
      </text-field>
      <form @submit.prevent="handleWithdrawalSubmit">
        <textInput
          field-id="invoice"
          field-type="text"
          field-placeholder="Ingresa el invoice aqui "
          field-name="invoice"
          v-model="invoice"
        />
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

export default {
  name: 'ProfileOpenNode',
  components: {
    TextField,
    textInput,
    submitButton,
    SelectInput,
  },
  data() {
    return {
      currencyOptions: ['BTC', 'CLP'],
      amount: '',
      currency: 'BTC',
      invoice: '',
    };
  },
  computed: {
    chargeAllowed() {
      return !(this.amount && this.currency);
    },
    withdrawalAllowed() {
      return !this.invoice;
    },
  },
  methods: {
    ...mapActions('user', ['withdrawalOpenNode']),
    handleChargeSubmit() {
      console.log('charge');
      const { amount, currency } = this;
      console.log(amount, currency);
    },
    handleWithdrawalSubmit() {
      const { invoice } = this;

      return this.withdrawalOpenNode({ invoice });
    },
  },
};
</script>
