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
        <div v-if="budaSignedIn" class="p-3">
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
          <div v-if="getBalanceLoading">
            <span class="block text-gray-700 text-lg py-2">
              Cargando tu saldo...
            </span>
          </div>
          <div v-else>
            <span
              v-if="checkBitsplitBalance() || checkBudaBalance()"
              class="block text-gray-700 text-lg py-2"
            >
              Wallet desde la que se enviará el pago:
              {{ currentWallet() | capitalize }}
            </span>
            <span v-else class="block text-gray-700 text-lg py-2">
              No hay saldo suficiente en ninguna de tus wallet :(
            </span>
          </div>
          <select
            v-if="budaSignedIn"
            class="txt-input appearance-none border rounded w-full my-4 py-2 px-3 leading-tight"
            v-model="wallet_origin_selected"
          >
            <option value="" disabled selected>
              Cambiar Wallet
            </option>
            <option value="bitsplit" :disabled="!checkBitsplitBalance()">
              Bitsplit
            </option>
            <option value="buda" :disabled="!checkBudaBalance()">
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
          <div class="flex flex-col">
            <label class="block text-gray-700 text-lg" for="account_balance"
              >Equivalente a:</label
            >
            <label
              v-if="splitwisePaymentData.currency_code === 'btc'"
              class="mb-4 uppercase font-bold text-xl text-indigo-600"
              for="account_balance"
              >{{ quotationCLP }} CLP</label
            >
            <label
              v-if="splitwisePaymentData.currency_code === 'clp'"
              class="mb-4 uppercase font-bold text-xl text-indigo-600"
              for="account_balance"
              >{{ quotationBTC }} BTC</label
            >
          </div>
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
          <submitButton
            v-if="existing_user"
            width="full"
            :loading="sendPaymentLoading || !checkCurrentWalletBalance()"
          >
            Pagar
          </submitButton>
          <DoubleSubmitButton
            v-else
            width="full"
            :email="receiver_email"
            :loading="sendPaymentLoading || !checkCurrentWalletBalance()"
          >
            Pagar
          </DoubleSubmitButton>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex';
import textInput from '../Input';
import submitButton from '../SubmitButton';
import DoubleSubmitButton from '../DoubleSubmitButton';

import spinner from '../Spinner';

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
const BTC_QUOTATION_BASE = 1000;
const CLP_DECIMALS = 2;
const BTC_DECIMALS = 8;

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
      existing_user: true,
    };
  },
  components: {
    textInput,
    submitButton,
    spinner,
    DoubleSubmitButton,
  },
  computed: {
    ...mapState('user', [
      'currentUser',
      'sendPaymentLoading',
      'getBalanceLoading',
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
    this.checkExistingEmail();
  },
  watch: {
    amount: debounce(function () {
      this.getNewQuotation();
    }, DEBOUNCE_TIMER),
  },
  filters: {
    capitalize(value) {
      if (!value) return '';
      const valueA = value.toString();

      return valueA.charAt(0).toUpperCase() + valueA.slice(1);
    },
  },
  methods: {
    ...mapActions('user', [
      'getQuotation',
      'getUserBalance',
      'sendSplitwisePayment',
      'checkEmailExists',
    ]),
    ...mapActions('component', ['changeSplitwisePaymentComp']),
    checkExistingEmail() {
      const receiver_email = this.splitwisePaymentData.email;
      if (receiver_email) {
        this.checkEmailExists({ email: receiver_email })
          .then(result => {
            this.existing_user = result;
          })
          .catch(() => {
            this.existing_user = false;
          });
      }
    },
    getNewQuotation() {
      const { amount, currency_code } = this.splitwisePaymentData;
      if (amount) {
        this.getQuotation({ amount: BTC_QUOTATION_BASE })
          .then(balance => {
            if (currency_code === 'clp') {
              this.quotationBTC = (
                (amount * balance.amount_btc[0]) /
                BTC_QUOTATION_BASE
              ).toFixed(BTC_DECIMALS);
            } else if (currency_code === 'btc') {
              this.quotationCLP = (
                (amount * BTC_QUOTATION_BASE) /
                balance.amount_btc[0]
              ).toFixed(CLP_DECIMALS);
            }
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
    currentWallet() {
      let wallet;
      const bitsplitBalance = this.checkBitsplitBalance();
      const budaBalance = this.checkBudaBalance();

      if (this.wallet_origin_selected) {
        wallet = this.wallet_origin_selected;
      } else {
        if (this.currentUser.wallet === 'bitsplit') {
          if (bitsplitBalance) {
            wallet = 'bitsplit';
          } else {
            if (this.budaSignedIn && budaBalance) {
              wallet = 'buda';
            }
          }
        } else if (this.currentUser.wallet === 'buda') {
          if (budaBalance) {
            wallet = 'buda';
          } else {
            if (bitsplitBalance) {
              wallet = 'bitsplit';
            }
          }
        }
      }

      return wallet;
    },
    checkCurrentWalletBalance() {
      const wallet = this.currentWallet();
      if (wallet) {
        const walletBalanceBTC =
          wallet === 'bitsplit'
            ? this.checkBitsplitBalance()
            : this.checkBudaBalance();

        return walletBalanceBTC;
      }

      return false;
    },
    checkBudaBalance() {
      const paymentAmountBTC = this.paymentAmountBTC();
      const { userBalanceBudaBTC } = this;

      return userBalanceBudaBTC >= paymentAmountBTC;
    },
    checkBitsplitBalance() {
      const paymentAmountBTC = this.paymentAmountBTC();
      const { userBalanceBitsplitBTC } = this;

      return userBalanceBitsplitBTC >= paymentAmountBTC;
    },
    paymentAmountBTC() {
      const { amount, quotationBTC } = this;
      const { currency_code } = this.splitwisePaymentData;

      return currency_code === 'clp'
        ? parseFloat(quotationBTC)
        : parseFloat(amount);
    },
    handleSubmit() {
      const wallet = this.currentWallet();
      const paymentAmountBTC = this.paymentAmountBTC();
      const {
        group_id,
        to_user_id,
        first_name,
        last_name,
        email,
        amount,
        currency_code,
      } = this.splitwisePaymentData;

      if (amount && email) {
        this.sendSplitwisePayment({
          payment_amount: paymentAmountBTC,
          group_id,
          to_user_id,
          first_name,
          last_name,
          receiver_email: email,
          amount_clp: parseFloat(amount),
          amount: parseFloat(amount),
          amount_btc: parseFloat(this.quotationBTC),
          currency_code: currency_code.toUpperCase(),
          wallet_origin: wallet,
        })
          .then(() => {
            this.changeSplitwisePaymentComp('SplitwisePaymentConfirm');
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
