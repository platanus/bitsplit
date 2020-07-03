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
            <span
              class="block text-gray-700 text-lg py-2"
            >
              Cargando tu saldo...
            </span>
          </div>
          <div v-else>
            <span
              v-if="userBalanceBitsplitBTC || userBalanceBudaBTC"
              class="block text-gray-700 text-lg py-2"
            >
              Wallet desde la que se enviará el pago:
              {{
                currentWallet() | capitalize
              }}
            </span>
            <span
              v-else
              class="block text-gray-700 text-lg py-2"
            >
              No hay saldo en ninguna de tus wallet :(
            </span>
          </div>
          <select v-if="budaSignedIn"
            class="txt-input appearance-none border rounded w-full my-4 py-2 px-3 leading-tight"
            v-model="wallet_origin_selected"
          >
            <option value="" disabled selected>
              Cambiar Wallet
            </option>
            <option value="bitsplit" :disabled="!userBalanceBitsplitBTC">
              Bitsplit
            </option>
            <option value="buda" :disabled="!userBalanceBudaBTC">
              Buda
            </option>
          </select>
          <div class="flex">
            <div class="w-5/6 pr-2">
              <textInput
                field-id="amount"
                field-type="number"
                field-placeholder="Monto a transferir"
                field-name="amount"
                v-model="amount"
              />
            </div>
            <div class="w-1/6 pl-2">
              <select
                v-model="currency_selected"
                class="txt-input appearance-none border rounded w-full mb-4 py-2 px-3 leading-tight"
              >
                <option value="btc">
                  BTC
                </option>
                <option value="clp">
                  CLP
                </option>
              </select>
            </div>
          </div>
        </div>
        <div class="flex flex-col mb-6 mt-6">
          <div class="flex flex-col">
            <label class="block text-gray-700 text-lg" for="account_balance"
              >Equivalente a:</label
            >
            <label v-if="currency_selected === 'btc'"
              class="mb-4 uppercase font-bold text-xl text-indigo-600"
              for="account_balance"
              >{{ quotationCLP }} CLP</label
            >
            <label v-if="currency_selected === 'clp'"
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
            v-model="receiver_email"
          />
        </div>
        <div>
          <submitButton width="full" :loading="sendPaymentLoading || button_disabled || !checkCurrentWalletBalance()">
            Pagar
          </submitButton>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex';
import _ from 'lodash';
import textInput from '../Input';
import submitButton from '../SubmitButton';
import spinner from '../Spinner';

const DEBOUNCE_TIMER = 1500;
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
      currency_selected: 'btc',
      quotationCLP: 0,
      quotationBTC: 0,
      button_disabled: false,
    };
  },
  components: {
    textInput,
    submitButton,
    spinner,
  },
  created() {
    this.debounceAmount = _.debounce( function() {
      this.getNewQuotation()
      this.button_disabled = false
    }, DEBOUNCE_TIMER)
    this.debounceEmail = _.debounce( function() {
      this.button_disabled = false
    }, DEBOUNCE_TIMER)
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
    ]),
    ...mapGetters('user', ['budaSignedIn']),
  },
  watch: {
    amount: {
      handler: function() {
        this.button_disabled = true
        this.debounceAmount()
      }
    },
    receiver_email: {
      handler: function() {
        this.button_disabled = true
        this.debounceEmail()
      }
    },
    currency_selected: {
      handler: function() {
        this.amount = '';
        this.quotationCLP = 0;
        this.quotationBTC = 0;
      }
    }
  },
  filters: {
    capitalize: function (value) {
      if (!value) return ''
      value = value.toString()
      return value.charAt(0).toUpperCase() + value.slice(1)
    },
  },
  methods: {
    ...mapActions('user', ['getQuotation', 'sendPayment']),
    ...mapActions('component', ['changePaymentComp']),
    getNewQuotation() {
      const { amount , currency_selected } = this;
      if (amount) {
        this.getQuotation({ amount: BTC_QUOTATION_BASE })
          .then(balance => {
            if (currency_selected === 'clp') {
              this.quotationBTC = ((amount * balance.amount_btc[0]) / BTC_QUOTATION_BASE).toFixed(BTC_DECIMALS);
            }
            else if (currency_selected === 'btc') {
              this.quotationCLP = ((amount * BTC_QUOTATION_BASE) / balance.amount_btc[0]).toFixed(CLP_DECIMALS);
            }
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
    currentWallet() {
      var wallet;

      if (this.wallet_origin_selected) {
        wallet = this.wallet_origin_selected
      }
      else {
        if (this.currentUser.wallet === 'bitsplit') {
          if (this.userBalanceBitsplitBTC) {
            wallet = 'bitsplit'
          }
          else {
            if (this.budaSignedIn && this.userBalanceBudaBTC) {
              wallet = 'buda'
            }
          }
        }
        else if (this.currentUser.wallet === 'buda') {
          if (this.userBalanceBudaBTC) {
            wallet = 'buda'
          }
          else {
            if (this.userBalanceBitsplitBTC) {
              wallet = 'bitsplit'
            }
          }
        }
      }

      return wallet;
    },
    checkCurrentWalletBalance() {
      const wallet = this.currentWallet()
      if (wallet) {
        const walletBalanceBTC = wallet === 'bitsplit' 
                                ? this.checkBitsplitBalance()
                                : this.checkBudaBalance()
        return walletBalanceBTC
      }
      else return false   
    },
    checkBudaBalance() {
      const paymentAmountBTC = this.paymentAmountBTC()
      const { userBalanceBudaBTC, budaSignedIn } = this

      return budaSignedIn && userBalanceBudaBTC >= paymentAmountBTC
    },
    checkBitsplitBalance() {
      const paymentAmountBTC = this.paymentAmountBTC()
      const { userBalanceBitsplitBTC } = this

      return userBalanceBitsplitBTC >= paymentAmountBTC
    },
    paymentAmountBTC() {
      const { amount, quotationBTC, currency_selected } = this;
      return currency_selected === 'clp'
              ? parseFloat(quotationBTC)
              : parseFloat(amount)
    },
    handleSubmit() {
      const wallet = this.currentWallet();
      const paymentAmountBTC = this.paymentAmountBTC()
      const { amount, receiver_email } = this;

      if (amount && receiver_email) {
        this.sendPayment({
          payment_amount: paymentAmountBTC,
          receiver_email: receiver_email,
          wallet_origin: wallet,
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
