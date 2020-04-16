<template>
  <button @click="$emit('do-click')"
    :class= "[classmod,'text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline']"
    :disabled= fieldDisabled 
  >
    {{ fieldPlaceholder }}
  </button>
</template>
<script>
export default {
  name: 'SubmitButton',
  props: {
    fieldDisabled: Boolean,
    fieldPlaceholder: String,
    classmod: {
        type: String,
        default: ''
      }
  }
}
</script>
