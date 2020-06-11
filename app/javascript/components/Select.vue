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
      v-for="option in options"
      :key="option"
      :value="option"
      :selected="option === value ? 'selected' : null"
    >
      {{ nameMappings[option] }}
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
    options: Array,
    nameMappings: Object,
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
