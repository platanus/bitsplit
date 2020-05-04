<template>
  <button
    v-if="!loading"
    class='text-white font-bold p-2 rounded focus:outline-none'
    :class="[
      width === 'full' ? 'w-full' : 'w-normal',
      color === 'secondary' ? 'bg-indigo-500 hover:bg-indigo-700' : 'bg-blue-500 hover:bg-blue-700'
    ]"
  >
    <slot />
  </button>
  <button
    v-else
    class='text-white font-bold p-2 rounded focus:outline-none'
    :class="[
      width === 'full' ? 'w-full' : 'w-normal',
      color === 'secondary' ? 'bg-indigo-200' : 'bg-blue-200'
    ]"
    :disabled="true"
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
      default: null
    }
  }
}
</script>
