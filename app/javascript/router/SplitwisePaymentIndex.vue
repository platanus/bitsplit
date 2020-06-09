<template>
  <div>
    <component :is="splitwisePaymentComp" />
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import SplitwisePaymentForm from '../components/SplitwisePaymentForm';
import SplitwisePaymentConfirm from '../components/SplitwisePaymentConfirm';

export default {
  name: 'SplitwisePayment',
  data() {
    return {
      routeName: 'SplitwisePayment',
    };
  },
  components: {
    SplitwisePaymentForm,
    SplitwisePaymentConfirm,
  },
  computed: {
    ...mapState('component', ['splitwisePaymentComp']),
  },
  methods: {
    ...mapActions('component', ['changeSplitwisePaymentComp']),
  },
  created() {
    this.changeSplitwisePaymentComp('SplitwisePaymentForm');
  },
};
</script>
