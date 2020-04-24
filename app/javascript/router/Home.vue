<template>
  <div class="m-12">
    <div v-if="!budaSignedIn">
      <BudaAlert></BudaAlert>
    </div>
    <div class="bg-gray-200 p-10 my-4 rounded-md">
      <p class="text-5xl font-bold">BitSplit</p>
      <p
        class="font-light"
      >Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam</p>
    </div>
    <div
      class="flex flex-col justify-center md:flex-row md:justify-start bg-gray-200 p-10 rounded-md"
    >
      <UserCard
        :email="currentUser.email"
        :clp_balance="userBalanceCLP"
        :btc_balance="userBalanceBTC"
        classmod="self-center"
      />
      <div class="flex flex-col md:flex-row md:items-start text-center px-4 py-2">
        <LinkButton v-if="budaSignedIn"
          classmod="bg-blue-500 hover:bg-blue-700 mx-4 my-3 md:my-0"
          :fieldDisabled="false"
          route="payment"
        >Hacer un pago</LinkButton>
        <LinkButton
          classmod="bg-blue-500 hover:bg-blue-700 mx-4"
          :fieldDisabled="false"
          route="payment"
        >Ver mis transacciones</LinkButton>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'
import BudaAlert from 'components/BudaAlert.vue'
import LinkButton from '../components/LinkButton'
import UserCard from '../components/UserCard'

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home'
    }
  },

  created() {
    if (this.budaSignedIn) {
      this.getUserBalance()
    }
  },
  components: {
    BudaAlert,
    LinkButton,
    UserCard
  },
  methods: {
    ...mapActions('user', ['getUserBalance'])
  },
  computed: {
    ...mapState('user', ['currentUser', 'userBalanceCLP', 'userBalanceBTC']),
    ...mapGetters('user', ['budaSignedIn'])
  }
}
</script>

<style lang="scss"></style>
