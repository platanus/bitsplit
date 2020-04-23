<template id="full">
  <div id="PaymentForm">
    <center>
      <div class="w-full max-w-xs">
        <form @submit.prevent="handleSubmit" class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
          <div class="flex flex-col mb-6 mt-4">
            <label class="block text-gray-700 text-lg" for="account_balance">Saldo disponible:</label>
            <label
              class="mb-4 uppercase font-bold text-xxl text-indigo-600"
              for="account_balance"
            >${{ userBalanceCLP }} CLP</label>
            <label
              class="mb-4 uppercase font-bold text-xxl text-indigo-600"
              for="account_balance"
            >${{ userBalanceBTC }} BTC</label>
            <textInput
              fieldId="amount"
              fieldType="text"
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
            >{{ quotationBTC}} BTC</label>
            <textInput
              fieldId="receiver_email"
              fieldType="text"
              fieldPlaceholder="Email destinatario"
              fieldName="receiver_email"
              v-model="receiver_email"
            />
          </div>
          <div>
            <submitButton size="full" :fieldDisabled="false">Pagar</submitButton>
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
      amount: '',
      receiver_email: '',
      quotationCLP: 0,
      quotationBTC: 0
    }
  },
  components: {
    textInput,
    submitButton,
    inputLabel
  },
  computed: {
    ...mapState('user', ['currentUser', 'userBalanceCLP', 'userBalanceBTC'])
  },
  created() {
    const { email, authentication_token } = this.currentUser
    this.getUserBalance({ email, authentication_token })
  },
  watch: {
    amount: debounce(function() {
      this.getNewQuotation()
    }, 1000)
  },
  methods: {
    ...mapActions('user', ['getQuotation', 'getUserBalance', 'sendPayment']),
    getNewQuotation() {
      const { amount } = this
      if (amount >= 100) {
        const { email, authentication_token } = this.currentUser
        this.getQuotation({ amount, email, authentication_token })
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
        const { email, authentication_token } = this.currentUser
        this.sendPayment({
          payment_amount: parseFloat(amount),
          receiver_email,
          email,
          authentication_token
        })
          .then(() => {
            // TODO confirm page
            console.log('success')
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
