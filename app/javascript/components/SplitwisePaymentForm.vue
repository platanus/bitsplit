<template>
  <div class="flex justify-center m-16">
    <div class="w-full max-w-xs">
      <spinner v-if="sendPaymentLoading" />
      <div class="p-3">
        <div class="border-b border-t p-3 mt-4">
          <div
            class="flex flex-col items-center sm:flex-row justify-between pb-3 text-grey-dark"
          >
            <h2 class="font-normal">
              Dinero en Bitsplit
            </h2>
            <div class="flex mr-3 font-thin">
              <div class="text-center mr-3 pr-3">
                <h2>{{ userBalanceBitsplitBTC }}</h2>
                <span>BTC</span>
              </div>
              <div class="text-center mr-3 pr-3">
                <h2>${{ userBalanceBitsplitBTCCLP }}</h2>
                <span>CLP aprox</span>
              </div>
            </div>
          </div>
        </div>
        <div class="p-3">
          <div
            class="flex flex-col items-center sm:flex-row justify-between pb-3 text-grey-dark"
          >
            <h2 class="font-normal">
              Dinero en Buda
            </h2>
            <div class="flex mr-3 font-thin">
              <div class="text-center mr-3 pr-3">
                <h2>{{ userBalanceBudaBTC }}</h2>
                <span>BTC</span>
              </div>
              <div class="text-center mr-3 border-r pr-3">
                <h2>${{ userBalanceBudaBTCCLP }}</h2>
                <span>CLP aprox</span>
              </div>
              <div class="text-center">
                <h2>${{ userBalanceBudaCLP }}</h2>
                <span>CLP</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <form @submit.prevent="handleSubmit">
        <div class="flex flex-col mb-6 mt-6">
          <label class="block text-gray-700 text-lg" for="account_balance"
            >Wallet Actual:
            {{
              currentWallet().charAt(0).toUpperCase() + currentWallet().slice(1)
            }}
          </label>
          <select
            class="txt-input appearance-none border rounded w-full my-4 py-2 px-3 leading-tight"
            v-model="wallet_origin_selected"
          >
            <option value="" disabled selected>
              Cambiar Wallet
            </option>
            <option value="bitsplit">
              Bitsplit
            </option>
            <option v-if="budaSignedIn" value="buda">
              Buda
            </option>
          </select>
          <div class="flex">
            <div class="w-5/6 pr-2">
              <textInput
                field-id="amount"
                field-type="number"
                field-name="amount"
                :value="splitwisePaymentData.amount"
                disabled
              />
            </div>
            <div class="w-1/6 pl-2">
              <textInput
                field-id="currency_code"
                field-name="currency_code"
                :value="splitwisePaymentData.currency_code.toUpperCase()"
                disabled
              />
            </div>
          </div>
        </div>
        <div class="flex flex-col mb-6 mt-6">
          <label class="block mt-4 text-gray-700 text-lg" for="account_balance"
            >Equivalente:</label
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
            :value="splitwisePaymentData.email"
            disabled
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
import { mapActions, mapState, mapGetters } from 'vuex';
import textInput from '../components/Input';
import submitButton from '../components/SubmitButton';
import spinner from '../components/Spinner';

// eslint-disable-next-line func-style
function debounce(func, wait, immediate) {
  let timeout;

  return function (...args) {
    const self = this;
    const later = function () {
      timeout = null;
      if (!immediate) func.apply(self, args);
    };
    const callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(self, args);
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
      wallet_origin_selected: '',
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
      'userBalanceBudaCLP',
      'userBalanceBudaBTC',
      'userBalanceBudaBTCCLP',
      'userBalanceBitsplitBTC',
      'userBalanceBitsplitBTCCLP',
      'splitwisePaymentData',
    ]),
    ...mapGetters('user', ['budaSignedIn']),
  },
  created() {
    this.getUserBalance();
  },
  mounted() {
    this.getNewQuotation();
  },
  watch: {
    amount: debounce(function () {
      this.getNewQuotation();
    }, DEBOUNCE_TIMER),
  },
  methods: {
    ...mapActions('user', [
      'getQuotation',
      'getUserBalance',
      'sendSplitwisePayment',
    ]),
    ...mapActions('component', ['changeSplitwisePaymentComp']),
    getNewQuotation() {
      const { amount, currency_code } = this.splitwisePaymentData;
      if (amount >= MIN_PAYMENT && currency_code === 'clp') {
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
    currentWallet() {
      const wallet = this.wallet_origin_selected
        ? this.wallet_origin_selected
        : this.currentUser.wallet;

      return wallet;
    },
    handleSubmit() {
      const wallet = this.currentWallet();
      const {
        group_id,
        to_user_id,
        first_name,
        last_name,
        email,
        amount,
        currency_code,
      } = this.splitwisePaymentData;
      this.sendSplitwisePayment({
        payment_amount:
          currency_code === 'clp'
            ? parseFloat(this.quotationBTC)
            : parseFloat(amount),
        group_id,
        to_user_id,
        first_name,
        last_name,
        receiver_email: email,
        amount_clp: parseFloat(amount),
        amount_btc: parseFloat(this.quotationBTC),
        currency_code,
        wallet_origin: wallet,
      })
        .then(() => {
          this.changeSplitwisePaymentComp('SplitwisePaymentConfirm');
        })
        .catch(err => {
          console.error(err);
        });
    },
  },
};
</script>

<style scoped>
.max-w-xs {
  max-width: 34rem;
}
</style>
