<template>
  <div class="flex justify-end flex-row">
    <input
      class="txt-input rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
      :id="fieldId"
      :type="inputType"
      :placeholder="fieldPlaceholder"
      :name="fieldName"
      :value="value"
      @input="$emit('update', $event.target.value)"
    >
    <img
      @click="swapPassword()"
      :src="noVisibility"
      class="absolute transform translate-y-3 -translate-x-4"
      align="top"
    >
  </div>
</template>
<script>

import noVis from '../assets/no-visibility.svg';

export default {
  name: 'PasswordForm',
  data() {
    return {
      inputType: 'password',
      noVisibility: noVis,
    };
  },
  props: {
    value: String,
    fieldId: String,
    fieldName: String,
    fieldPlaceholder: {
      default: '****************',
      type: String,
    },
  },
  model: {
    prop: 'value',
    event: 'update',
  },
  methods: {
    swapPassword() {
      this.inputType = this.inputType === 'password' 
                        ? 'text' 
                        : 'password'
    },
  }
};
</script>
