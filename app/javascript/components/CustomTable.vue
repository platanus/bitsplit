<template>
  <table class="table-auto bg-white sm:bg-white sm:shadow-lg">
    <thead class="bg-indigo-500 text-white">
      <tr class="sm:table-row sm:mb-0">
        <th class="p-3" v-for="(column, index) in columns" :key="index">
          {{ column }}
        </th>
      </tr>
    </thead>
    <tbody class="sm:flex-none">
      <tr
        class="sm:table-row sm:mb-0"
        v-for="(item, index) in data.slice(0, limit)"
        :key="index"
      >
        <slot :row="item" :tdClass="tdClass" />
      </tr>
    </tbody>
  </table>
</template>

<script>
export default {
  name: 'CustomTable',
  data() {
    return {
      tdClass: 'p-3',
    };
  },
  props: {
    columns: Array,
    data: Array,
    limit: { type: Number, default: Infinity },
  },
};
</script>
<style lang="scss"></style>
