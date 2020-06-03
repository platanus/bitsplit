<template>
  <table class="table-auto bg-white">
    <thead class="bg-indigo-500 text-white">
      <tr>
        <th class="p-3" v-for="(column, index) in columns" :key="index">
          {{ column }}
        </th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(item, index) in data" :key="index">
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
