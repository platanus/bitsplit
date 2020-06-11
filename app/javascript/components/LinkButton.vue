<template>
  <button
    @click="moveMe()"
    class="btn ext-black font-bold p-2 rounded focus:outline-none"
    :class="[
      width === 'full' ? 'w-full' : 'w-normal',
      !loading
        ? color === 'secondary'
          ? 'bg-indigo-500 hover:bg-indigo-700'
          : ''
        : color === 'secondary'
        ? 'bg-indigo-200 cursor-not-allowed'
        : 'cursor-not-allowed',
    ]"
    :disabled="loading"
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
    fieldPlaceholder: String,
    color: String,
    width: String,
    route: String,
    loading: {
      type: Boolean,
      default: false,
    },
    paymentData: {
      type: Object,
      default: null,
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
