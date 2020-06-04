<template>
  <div class="m-12">
    <div v-if="!budaSignedIn">
      <BudaAlert />
    </div>
    <div class="bg-gray-200 p-10 my-4 rounded-md">
      <p class="text-5xl font-bold">
        BitSplit
      </p>
      <p class="font-light">
        Bienvenido a BitSplit, el sitio donde podrás pagar facilmente a tus
        amigos, cobrar deudas y manejar dinero. Todo esto de forma fácil,
        intuitiva e internacional!
      </p>
    </div>
    <div
      class="flex flex-col justify-center lg:flex-row lg:justify-between bg-gray-200 p-10 rounded-md"
    >
      <div class="lg:pr-5 flex flex-col">
        <UserCard classmod="self-center" />
        <div class="text-center px-4 py-2">
          <LinkButton
            v-if="budaSignedIn"
            classmod="bg-blue-500 hover:bg-blue-700 my-3 md:my-0"
            :field-disabled="false"
            route="payment"
          >
            Hacer un pago
          </LinkButton>
        </div>
      </div>
      <div>
        <CustomTable
          :data="paymentsHistory.slice().reverse()"
          :columns="tableColumns"
        >
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
            <td class="border-grey-light border hover:bg-gray-100 p-3 truncate">
              {{ row.attributes.amount }} BTC
            </td>
            <td class="border-grey-light border hover:bg-gray-100 p-3">
              {{ getDate(row.attributes.created_at) }}
            </td>
          </template>
        </CustomTable>
      </div>
    </div>
    <div class="bg-gray-200 p-10 my-4 rounded-md">
      <p class="text-5xl font-bold">
        Splitwise
      </p>
      <div v-if="userDebts.user_to_friends && userDebts.user_to_friends.length">
        <p class="text-5xl font-bold">
          Deudas a amigos
        </p>
        <CustomTable
          :data="userDebts.user_to_friends.slice().reverse()"
          :columns="debtsColumns"
        >
          <template slot-scope="{ row }">
            <td class="border-grey-light border hover:bg-gray-100 p-3">
              {{ row.from.first_name + ' ' + row.from.last_name }}
            </td>
            <td class="border-grey-light border hover:bg-gray-100 p-3">
              {{ row.to.first_name + ' ' + row.to.last_name }}
            </td>
            <td class="border-grey-light border hover:bg-gray-100 p-3">
              ${{ row.amount }}
            </td>
            <td class="border-grey-light border hover:bg-gray-100 p-3 truncate">
              {{ row.group_name }}
            </td>
            <td
              v-show="row.is_payable"
              class="border-grey-light border hover:bg-gray-100 p-3 truncate"
            >
              <LinkButton
                classmod="bg-blue-500 hover:bg-blue-700 my-3 md:my-0"
                :field-disabled="true"
              >
                Pagar
              </LinkButton>
            </td>
          </template>
        </CustomTable>
      </div>
      <div v-if="userDebts.friends_to_user && userDebts.friends_to_user.length">
        <p class="text-5xl font-bold">
          Deudas de amigos hacia ti
        </p>
        <CustomTable
          :data="userDebts.friends_to_user.slice().reverse()"
          :columns="debtsColumns"
        >
          <template slot-scope="{ row }">
            <td class="border-grey-light border hover:bg-gray-100 p-3">
              {{ row.from.first_name + ' ' + row.from.last_name }}
            </td>
            <td class="border-grey-light border hover:bg-gray-100 p-3">
              {{ row.to.first_name + ' ' + row.to.last_name }}
            </td>
            <td class="border-grey-light border hover:bg-gray-100 p-3">
              ${{ row.amount }}
            </td>
            <td class="border-grey-light border hover:bg-gray-100 p-3 truncate">
              {{ row.group_name }}
            </td>
          </template>
        </CustomTable>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import BudaAlert from 'components/BudaAlert.vue';
import LinkButton from '../components/LinkButton';
import UserCard from '../components/UserCard';
import CustomTable from '../components/CustomTable';

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home',
      tableColumns: ['Tipo', 'Envía', 'Recibe', 'Cantidad', 'Fecha'],
      debtsColumns: ['De', 'Para', 'Monto', 'Grupo', 'Pagar'],
    };
  },

  created() {
    this.getDebts();
    if (this.budaSignedIn) {
      this.getUserBalance();
      this.getPayments();
    }
  },
  components: {
    BudaAlert,
    LinkButton,
    UserCard,
    CustomTable,
  },
  methods: {
    ...mapActions('user', ['getUserBalance', 'getPayments', 'getDebts']),

    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
    },
  },
  computed: {
    ...mapState('user', ['currentUser', 'paymentsHistory', 'userDebts']),
    ...mapGetters('user', ['budaSignedIn']),
  },
};
</script>

<style></style>
