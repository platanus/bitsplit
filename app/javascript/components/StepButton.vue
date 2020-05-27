<template>
  <div
    @click="$emit('do-click')"
    class="px-1 h-auto bg-gray-200 hover:bg-gray-400 cursor-pointer flex flex-row justify-start"
    :disabled="loading"
  >
    <slot />
  </div>
</template>

<script>
export default {
  name: 'SubmitButton',
  props: {
    fieldDisabled: Boolean,
    loading: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
