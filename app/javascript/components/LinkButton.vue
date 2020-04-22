<template>
  <button
    @click="moveMe()"
    :class="[classmod,'text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline']"
    :disabled="fieldDisabled"
  >{{ fieldPlaceholder }}</button>
</template>
<script>
export default {
  name: 'LinkButton',
  props: {
    fieldDisabled: Boolean,
    fieldPlaceholder: String,
    route: String,
    classmod: {
      type: String,
      default: ''
    }
  },
  methods: {
    moveMe() {
      this.$router.push(`/${this.route}`)
    }
  }
}
</script>
