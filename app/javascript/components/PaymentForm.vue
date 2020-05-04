<template>
    <div class="flex justify-center m-16">
      <div class="w-full max-w-xs">
        <spinner v-if="paymentLoading" ></spinner>
        <form @submit.prevent="handleSubmit">
          <div class="flex flex-col mb-6 mt-6">
            <label class="block text-gray-700 text-lg" for="account_balance">Saldo disponible:</label>
            <label
              class="mb-4 uppercase font-bold text-xl text-indigo-600"
              for="account_balance"
            >${{ userBalanceCLP }} CLP</label>
            <label
              class="mb-4 uppercase font-bold text-xl text-indigo-600"
              for="account_balance"
            >${{ userBalanceBTC }} BTC</label>
            <textInput
              fieldId="amount"
              fieldType="number"
              fieldPlaceholder="Monto a transferir"
              fieldName="amount"
              v-model="amount"
            />
          </div>
          <div class="flex flex-col mb-6 mt-6">
            <label class="block mt-4 text-gray-700 text-lg" for="account_balance">Equivalente a:</label>
            <label
              class="mb-8 uppercase font-bold text-xl text-indigo-600"
              for="account_balance"
            >{{ quotationCLP }} CLP</label>
            <label
              class="mb-8 uppercase font-bold text-xl text-indigo-600"
              for="account_balance"
            >{{ quotationBTC }} BTC</label>
            <textInput
              fieldId="receiver_email"
              fieldType="text"
              fieldPlaceholder="Email destinatario"
              fieldName="receiver_email"
              v-model="receiver_email"
            />
          </div>
          <div>
            <submitButton width="full" :loading="paymentLoading">Pagar</submitButton>
          </div>
        </form>
      </div>
    </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import textInput from '../components/Input'
import inputLabel from '../components/InputLabel'
import submitButton from '../components/SubmitButton'
import spinner from '../components/Spinner'

export default {
  name: 'Payment',
  data() {
    return {
      routeName: 'PaymentRoute',
      amount: '',
      receiver_email: '',
      quotationCLP: 0,
      quotationBTC: 0
    }
  },
  components: {
    textInput,
    submitButton,
    inputLabel,
    spinner
  },
  computed: {
    ...mapState('user', ['currentUser', 'paymentLoading', 'userBalanceCLP', 'userBalanceBTC'])
  },
  created() {
    this.getUserBalance()
  },
  watch: {
    amount: debounce(function() {
      this.getNewQuotation()
    }, 1000)
  },
  methods: {
    ...mapActions('user', ['getQuotation', 'getUserBalance', 'sendPayment']),
    ...mapActions('component', ['changePaymentComp']),
    getNewQuotation() {
      const { amount } = this
      if (amount >= 100) {
        this.getQuotation({ amount })
          .then(balance => {
            this.quotationCLP = balance.amount_clp[0]
            this.quotationBTC = balance.amount_btc[0]
          })
          .catch(err => {
            console.error(err)
          })
      }
    },
    handleSubmit(e) {
      const { amount, receiver_email } = this
      if (amount && receiver_email) {
        this.sendPayment({
          payment_amount: parseFloat(this.quotationBTC),
          receiver_email
        })
          .then(() => {
            console.log('success')
            this.changePaymentComp('PaymentConfirm')
          })
          .catch(err => {
            console.error(err)
          })
      }
    }
  }
}

function debounce(func, wait, immediate) {
  var timeout
  return function() {
    var context = this,
      args = arguments
    var later = function() {
      timeout = null
      if (!immediate) func.apply(context, args)
    }
    var callNow = immediate && !timeout
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
    if (callNow) func.apply(context, args)
  }
}
</script>

<style scoped>
.max-w-xs {
  max-width: 34rem;
}
</style>
