<template id="full">
  <div id="PaymentForm">
    <center>
      <div class="w-full max-w-xs">
        <form
          @submit.prevent=""
          class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
        >
          <div class="flex flex-col mb-6 mt-4">
            <label class="block text-gray-700 text-lg " for="account_balance">
              Saldo disponilbe:
            </label>
            <label
              class="mb-4 uppercase font-bold text-xxl text-indigo-600"
              for="account_balance"
              >${{ account_balance }} CLP</label
            >
            <textInput
              fieldId="payment_amount"
              fieldType="text"
              fieldPlaceholder="Monto a transferir"
              fieldName="payment_amount"
              v-model="payment_amount"
            />
          </div>
          <div class="flex flex-col mb-6 mt-6">
            <label
              class="block mt-4 text-gray-700 text-lg "
              for="account_balance"
            >
              Equivalente a:
            </label>
            <label
              class="mb-8 uppercase font-bold text-xl text-indigo-600"
              for="account_balance"
              >{{ bitcoin_equivalent }} BTC</label
            >
            <textInput
              fieldId="receiver_email"
              fieldType="text"
              fieldPlaceholder="Email destinatario"
              fieldName="receiver_email"
              v-model="receiver_email"
            />
          </div>
          <div>
            <submitButton
              classmod="mt-5 tracking-widest bg-indigo-600 hover:bg-indigo-700 w-full"
              :fieldDisabled="false"
              fieldPlaceholder="Pagar"
            />
          </div>
        </form>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import textInput from '../components/Input'
import inputLabel from '../components/InputLabel'
import submitButton from '../components/SubmitButton'

export default {
  name: 'Payment',
  data() {
    return {
      routeName: 'PaymentRoute',
      account_balance: '1000',
      bitcoin_equivalent: '0.1',
      payment_amount: '',
      receiver_email: ''
    }
  },
  components: {
    textInput,
    submitButton,
    inputLabel
  },
  computed: {
    ...mapState('component', ['budaProfileComp'])
  }
}
</script>

<style scoped>
#PaymentForm {
  margin-top: 60px;
  margin-bottom: 60px;
}
.text-xxl {
  font-size: 3.6rem;
}
.text-xl {
  font-size: 2.6rem;
}
.max-w-xs {
  max-width: 34rem;
}
.shadow-md {
  box-shadow: 0 10px 10px -1px rgba(85, 63, 167, 0.1),
    0 10px 10px -1px rgba(92, 63, 194, 0.06);
}
</style>
