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
export default {
  name: 'LinkButton',
  props: {
    fieldDisabled: Boolean,

    route: String,
    classmod: {
      type: String,
      default: '',
    },
  },
  methods: {
    moveMe() {
      this.$router.push(`/${this.route}`);
    },
  },
};
</script>
