<template>
  <button
    @click="$emit('do-click')"
    class='text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline'
    :class="[
      width === 'full' ? 'w-full' : 'w-normal',
      color === 'secondary' ? 'bg-indigo-500 hover:bg-indigo-700' : 'bg-blue-500 hover:bg-blue-700'
    ]"
    :disabled="fieldDisabled"
  >
    <slot />
  </button>
</template>
<script>
export default {
  name: 'SubmitButton',
  props: {
    fieldDisabled: Boolean,
    fieldPlaceholder: String,
    color: String,
    width: String
  }
}
</script>
