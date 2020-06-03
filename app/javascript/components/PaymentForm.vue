<template>
  <div class="flex justify-center m-16">
    <div class="w-full max-w-xs">
      <spinner v-if="sendPaymentLoading" />
      <form @submit.prevent="handleSubmit">
        <div class="flex flex-col mb-6 mt-6">
          <label class="block text-gray-700 text-lg" for="account_balance"
            >Saldo disponible:</label
          >
          <label
            class="mb-4 uppercase font-bold text-xl text-indigo-600"
            for="account_balance"
            >${{ userBalanceCLP }} CLP</label
          >
          <label
            class="mb-4 uppercase font-bold text-xl text-indigo-600"
            for="account_balance"
            >${{ userBalanceBTC }} BTC</label
          >
          <textInput
            field-id="amount"
            field-type="number"
            field-placeholder="Monto a transferir"
            field-name="amount"
            v-model="amount"
          />
        </div>
        <div class="flex flex-col mb-6 mt-6">
          <label class="block mt-4 text-gray-700 text-lg" for="account_balance"
            >Equivalente a:</label
          >
          <label
            class="mb-8 uppercase font-bold text-xl text-indigo-600"
            for="account_balance"
            >{{ quotationCLP }} CLP</label
          >
          <label
            class="mb-8 uppercase font-bold text-xl text-indigo-600"
            for="account_balance"
            >{{ quotationBTC }} BTC</label
          >
          <textInput
            field-id="receiver_email"
            field-type="text"
            field-placeholder="Email destinatario"
            field-name="receiver_email"
            v-model="receiver_email"
          />
        </div>
        <div>
          <submitButton width="full" :loading="sendPaymentLoading">
            Pagar
          </submitButton>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import textInput from '../components/Input';
import submitButton from '../components/SubmitButton';
import spinner from '../components/Spinner';

// eslint-disable-next-line func-style
function debounce(func, wait, immediate) {
  let timeout;

  return function (...args) {
    const later = function () {
      timeout = null;
      if (!immediate) func.apply(this, args);
    };
    const callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(this, args);
  };
}

const DEBOUNCE_TIMER = 1000;
const MIN_PAYMENT = 100;

export default {
  name: 'Payment',
  data() {
    return {
      routeName: 'PaymentRoute',
      amount: '',
      receiver_email: '',
      quotationCLP: 0,
      quotationBTC: 0,
    };
  },
  components: {
    textInput,
    submitButton,
    spinner,
  },
  computed: {
    ...mapState('user', [
      'currentUser',
      'sendPaymentLoading',
      'userBalanceCLP',
      'userBalanceBTC',
    ]),
  },
  created() {
    this.getUserBalance();
  },
  watch: {
    amount: debounce(function () {
      this.getNewQuotation();
    }, DEBOUNCE_TIMER),
  },
  methods: {
    ...mapActions('user', ['getQuotation', 'getUserBalance', 'sendPayment']),
    ...mapActions('component', ['changePaymentComp']),
    getNewQuotation() {
      const { amount } = this;
      if (amount >= MIN_PAYMENT) {
        this.getQuotation({ amount })
          .then(balance => {
            this.quotationCLP = balance.amount_clp[0];
            this.quotationBTC = balance.amount_btc[0];
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
    handleSubmit() {
      const { amount, receiver_email } = this;
      if (amount && receiver_email) {
        this.sendPayment({
          payment_amount: parseFloat(this.quotationBTC),
          receiver_email,
        })
          .then(() => {
            this.changePaymentComp('PaymentConfirm');
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
  },
};
</script>

<style scoped>
.max-w-xs {
  max-width: 34rem;
}
</style>
