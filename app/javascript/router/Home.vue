<template>
  <div class="m-12">
    <div v-if="!budaSignedIn">
      <BudaAlert></BudaAlert>
    </div>
    <div class="bg-gray-200 p-10 my-4 rounded-md">
      <p class="text-5xl font-bold">BitSplit</p>
      <p class="font-light">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
        veniam
      </p>
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
      <div
        class="flex flex-col md:flex-row md:items-start text-center px-4 py-2"
      >
        <LinkButton
          v-if="budaSignedIn"
          classmod="bg-blue-500 hover:bg-blue-700 mx-4 my-3 md:my-0"
          :fieldDisabled="false"
          route="payment"
          >Hacer un pago</LinkButton
        >
      </div>
      <body class="flex items-center justify-center">
        <div class="container">
          <CustomTable :data="paymentsHistory.slice().reverse()" :columns="tableColumns">
            <template slot-scope="{ row }">
              <td
                v-if="row.attributes.sender_email != currentUser.email"
                class="border-grey-light border hover:bg-gray-100 p-3"
              >
                <span
                  class="px-2 items-center inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800"
                >
                  Recibido
                </span>
              </td>
              <td v-else class="border-grey-light border hover:bg-gray-100 p-3">
                <span
                  class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800"
                >
                  Enviado
                </span>
              </td>
              <td class="border-grey-light border hover:bg-gray-100 p-3">
                {{ row.attributes.sender_email }}
              </td>
              <td class="border-grey-light border hover:bg-gray-100 p-3">
                {{ row.attributes.receiver_email }}
              </td>
              <td
                class="border-grey-light border hover:bg-gray-100 p-3 truncate"
              >
                {{ row.attributes.amount }} BTC
              </td>
              <td class="border-grey-light border hover:bg-gray-100 p-3">
                {{ getDate(row.attributes.created_at) }}
              </td>
            </template>
          </CustomTable>
        </div>
      </body>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'
import BudaAlert from 'components/BudaAlert.vue'
import LinkButton from '../components/LinkButton'
import UserCard from '../components/UserCard'
import CustomTable from '../components/CustomTable'

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home',
      tableColumns: ['Tipo', 'Envía', 'Recibe', 'Cantidad', 'Fecha']
    }
  },

  created() {
    if (this.budaSignedIn) {
      this.getUserBalance()
      this.getPayments()
    }
  },
  components: {
    BudaAlert,
    LinkButton,
    UserCard,
    CustomTable
  },
  methods: {
    ...mapActions('user', ['getUserBalance', 'getPayments']),
    getDate(date) {
      let d = new Date(date)
      return d.toLocaleString('en-US', { hour12: false })
    }
  },
  computed: {
    ...mapState('user', [
      'currentUser',
      'userBalanceCLP',
      'userBalanceBTC',
      'paymentsHistory'
    ]),
    ...mapGetters('user', ['budaSignedIn'])
  }
}
</script>

<style></style>
