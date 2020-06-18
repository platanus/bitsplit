<template>
  <div
    class="flex flex-row items-center bg-green-500 hover:bg-green-600 fixed bottom-0 right-0 mb-16 mr-8 p-2 rounded-md cursor-pointer"
  >
    <p class="text-white">
      {{ alert.message }}
    </p>
    <i class="material-icons text-center h-6 w-6 ml-2 text-gray-100">done</i>
  </div>
</template>

<script>
import { mapState } from 'vuex';

export default {
  name: 'SuccessAlert',
  computed: {
    ...mapState({
      alert: state => state.alert,
    }),
  },
};
</script>
