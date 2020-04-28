<template>
  <table
    class="table-auto  sm:bg-white rounded-lg overflow-hidden sm:shadow-lg my-5"
  >
    <thead class="text-white">
      <slot name="columns">
        <tr
          class="bg-indigo-500  flex flex-col flex-no wrap sm:table-row rounded-l-lg  mb-2"
        >
          <th  class="p-3 text-left" v-for="(column, index) in columns" v-bind:key="index">
            {{ column }}
          </th>
        </tr>
      </slot>
    </thead>
    <tbody class="flex-1 sm:flex-none">
      <template v-for="(item, index) in data">
        <tr class="flex flex-col flex-no wrap sm:table-row mb-2 sm:mb-0" v-bind:key="index">
          <slot :row="item">
            <td class="border-grey-light border hover:bg-gray-100 p-3" v-for="(column, index) in columns" v-bind:key="index">
              {{ itemValue(item, column) }}
            </td>
          </slot>
        </tr>
      </template>
    </tbody>
  </table>
</template>
<script>
export default {
  name: 'custom-table',
  props: {
    columns: Array,
    data: Array
  },
  methods: {
    itemValue(item, column) {
      return item[column.toLowerCase()]
    }
  }
}
</script>
<style lang="scss"></style>
