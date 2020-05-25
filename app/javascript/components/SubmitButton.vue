<template>
  <button
    @click.once="$emit('do-click')"
    class="btn w-full ext-black font-bold p-2 rounded focus:outline-none"
    :class="[
      width === 'full' ? 'w-full' : 'w-normal',
      loading === false ?
        color === 'secondary' ? 'bg-indigo-500 hover:bg-indigo-700' : 'bg-blue-500 hover:bg-blue-700' :
        color === 'secondary' ? 'bg-indigo-200' : 'bg-blue-200'
    ]"
    :disabled="
      loading === false ? false : true
    "
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
    width: String,
    loading: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
