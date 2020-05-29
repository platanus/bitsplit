<template>
  <label class="txt-field text-left flex justify-start items-start">
    <div
      class="bg-white border-2 rounded border-gray-400 w-6 h-6 flex flex-shrink-0 justify-center items-center mr-2 focus-within:border-blue-500"
    >
      <input
        type="checkbox"
        id="checkbox"
        class="opacity-0 absolute"
        :checked="!!isChecked"
        @change="e => (isChecked = e.target.checked)"
        @input="$emit('input', $event.target.checked)"
      >
      <svg
        class="fill-current hidden w-4 h-4 text-black-500 pointer-events-none"
        viewBox="0 0 20 20"
      >
        <path d="M0 11l2-2 5 5L18 3l2 2L7 18z" />
      </svg>
    </div>
    <div class="select-none">{{ fieldText }}</div>
  </label>
</template>

<script>
export default {
  name: 'Checkbox',
  props: {
    checked: Boolean,
    fieldText: String,
  },
  data: () => ({
    isChecked: false,
  }),
};
</script>

<style>
input:checked + svg {
  display: block;
}
</style>
