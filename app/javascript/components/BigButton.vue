<template>
  <button @click="$emit('do-click')"
    class="bg-indigo-600 hover:bg-indigo-700 w-full text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
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
    fieldPlaceholder: String
  }
}
</script>
