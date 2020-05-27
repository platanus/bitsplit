<template>
  <div>
    <div v-if="display" class="m-3 cursor-pointer" @click="$emit('do-click')">
      <div v-if="forward" class="flex flex-row">
        <slot name="text" />
        <slot name="icon" />
      </div>
      <div v-else class="flex flex-row">
        <slot name="icon" />
        <slot name="text" />
      </div>
    </div>
    <div v-else />
  </div>
</template>

<script>
export default {
  name: 'SubmitButton',
  props: {
    forward: {
      type: Boolean,
      default: true,
    },
    display: {
      type: Boolean,
      default: true,
    },
  },
};
</script>
