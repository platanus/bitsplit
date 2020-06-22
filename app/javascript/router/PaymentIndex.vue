<template>
  <div>
    <component :is="paymentComp" />
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import PaymentForm from '../components/payment/PaymentForm';
import PaymentConfirm from '../components/payment/PaymentConfirm';

export default {
  name: 'Payment',
  data() {
    return {
      routeName: 'Payment',
    };
  },
  components: {
    PaymentForm,
    PaymentConfirm,
  },
  computed: {
    ...mapState('component', ['paymentComp']),
  },
  methods: {
    ...mapActions('component', ['changePaymentComp']),
  },
  created() {
    this.changePaymentComp('PaymentForm');
  },
};
</script>
