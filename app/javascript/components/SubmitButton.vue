<template>
  <button
    @click.once="$emit('do-click')"
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
