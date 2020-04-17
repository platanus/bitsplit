<template>
  <div
    class="flex flex-row items-center bg-green-500 hover:bg-green-600 fixed bottom-0 right-0 mb-16 mr-8 p-2 rounded-md cursor-pointer"
  >
    <p class="text-white">{{ alert.message }}</p>
    <svg
      class="fill-current h-6 w-6 ml-4 text-gray-100"
      role="button"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 20 20"
    >
      <path
        d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"
      />
    </svg>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'
export default {
  name: 'successAlert',
  computed: {
    ...mapState({
      alert: state => state.alert
    })
  }
}
</script>
