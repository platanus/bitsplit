<template>
  <div class="flex justify-center m-16">
    <div class="flex flex-col mb-6 mt-6">
      <div>
        <textField
          font-size="full"
          font-color="secondary"
        >
          ¡Pago realizado con éxito!
        </textField>
      </div>
      <div>
        <textField>
          Monto: {{ this.lastPayment.amount }} BTC
        </textField>
        <textField>
          Receptor: {{ this.lastPayment.receiver }}
        </textField>
        <textField>
          Fecha: {{ getDate(this.lastPayment.date) }}
        </textField>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import textField from '../components/TextField';

export default {
  name: 'PaymentConfirm',
  data() {
    return {
      routeName: 'PaymentRoute',
      date: null,
    };
  },
  components: {
    textField,
  },
  computed: {
    ...mapState('user', ['currentUser', 'userBalanceCLP',
      'userBalanceBTC', 'lastPayment']),
  },
  created() {
    this.getUserBalance();
  },
  methods: {
    ...mapActions('user', ['getQuotation', 'getUserBalance', 'sendPayment']),
    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
    },
  },
};
</script>
