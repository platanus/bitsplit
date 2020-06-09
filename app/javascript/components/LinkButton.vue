<template>
  <button
    @click="moveMe()"
    :class="[
      'text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline',
      classmod,
    ]"
    :disabled="fieldDisabled"
  >
    <slot />
  </button>
</template>
<script>
import { mapActions } from 'vuex';

export default {
  name: 'LinkButton',
  props: {
    fieldDisabled: Boolean,
    route: String,
    paymentData: {
      type: Object,
      default: null,
    },
    classmod: {
      type: String,
      default: '',
    },
  },
  methods: {
    ...mapActions('user', ['setSplitwisePaymentData']),
    moveMe() {
      if (this.paymentData) {
        this.setSplitwisePaymentData(this.paymentData);
      }
      this.$router.push(`/${this.route}`);
    },
  },
};
</script>
