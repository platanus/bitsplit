<template>
  <select
    class="txt-input"
    :class="[
      classmod,
      'appearance-none border rounded w-full py-2 px-3  leading-tight focus:outline-none focus:shadow-outline',
    ]"
    :id="fieldId"
    :name="fieldName"
    @change="$emit('update', $event.target.value)"
  >
    <option disabled value="">
      Seleccione una opción
    </option>
    <option
      v-for="currencyCode in currencyOptions"
      :key="currencyCode"
      :value="currencyCode"
    >
      {{ currencyCode }}
    </option>
  </select>
</template>
<script>
export default {
  name: 'SelectInput',
  props: {
    fieldName: String,
    fieldId: String,
    value: String,
    currencyOptions: Array,
    classmod: {
      type: String,
      default: '',
    },
  },
  model: {
    prop: 'value',
    event: 'update',
  },
};
</script>
