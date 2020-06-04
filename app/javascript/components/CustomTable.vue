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
        v-for="(item, index) in data"
        :key="index"
      >
        <slot :row="item" />
      </tr>
    </tbody>
  </table>
</template>

<script>
export default {
  name: 'CustomTable',
  props: {
    columns: Array,
    data: Array,
  },
  mounted() {
    this.$nextTick(() => {
      this.$el.querySelectorAll('td').forEach(td => {
        td.classList.add('p-3');
      });
    });
  },
};
</script>
<style lang="scss"></style>
