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
      class="flex flex-col justify-start lg:flex-row bg-gray-200 p-10 rounded-md"
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
        <div>
          <p class="text-center text-xl font-bold mb-6">
            Últimas 5 transacciones
          </p>
        </div>
        <div class="justify-start">
          <div v-if="getPaymentsLoading">
            <p>Cargando...</p>
          </div>
          <div v-else class="bg-gray-200 rounded-md">
            <div v-if="userPaymentsHistory.length">
              <CustomTable
                :data="userPaymentsHistory"
                :columns="tableColumns"
                :limit="5"
              >
                <template #default="{ row }">
                  <td
                    class="border-grey-light border hover:bg-gray-100 p-3"
                    v-if="row.attributes.sender.email != currentUser.email"
                  >
                    <span
                      class="px-2 items-center inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800"
                    >
                      Recibido
                    </span>
                  </td>
                  <td
                    v-else
                    class="border-grey-light border hover:bg-gray-100 p-3"
                  >
                    <span
                      class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800"
                    >
                      Enviado
                    </span>
                  </td>
                  <td class="border-grey-light border hover:bg-gray-100 p-3">
                    {{ row.attributes.sender.email }}
                  </td>
                  <td class="border-grey-light border hover:bg-gray-100 p-3">
                    {{ row.attributes.receiver.email }}
                  </td>
                  <td class="border-grey-light border hover:bg-gray-100 p-3">
                    {{ row.attributes.amount_btc }} BTC
                  </td>
                  <td class="border-grey-light border hover:bg-gray-100 p-3">
                    $ {{ row.attributes.amount_clp.toFixed(0) }} CLP
                  </td>
                  <td class="border-grey-light border hover:bg-gray-100 p-3">
                    {{ getDate(row.attributes.created_at) }}
                  </td>
                </template>
              </CustomTable>
              <div class="text-center px-4 py-2">
                <LinkButton
                  classmod="bg-blue-500 hover:bg-blue-700 my-3 md:my-0"
                  :field-disabled="false"
                  route="payments-history"
                >
                  Ver más
                </LinkButton>
              </div>
            </div>
            <div v-else>
              <p class="text-5xl font-bold">
                No hay pagos para mostrar
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div
      class="flex flex-col justify-center lg:justify-between bg-gray-200 p-10 my-4 rounded-md"
    >
      <div>
        <div>
          <p class="text-5xl font-bold">
            Splitwise
          </p>
        </div>
        <div v-if="splitwiseSignedIn">
          <div v-if="getSplitwiseDebtsLoading">
            <p>Cargando...</p>
          </div>
          <div v-else class="bg-gray-200 rounded-md">
            <div>
              <div>
                <p class="text-5xl font-bold">
                  Deudas hacia amigos
                </p>
              </div>
              <div
                v-if="
                  userSplitwiseDebts.userToFriends.singleUserToFriends.length ||
                  userSplitwiseDebts.userToFriends.groupUserToFriends.length
                "
              >
                <div
                  v-if="
                    userSplitwiseDebts.userToFriends.singleUserToFriends.length
                  "
                >
                  <p class="text-5xl font-bold">
                    Deudas Individuales
                  </p>
                  <CustomTable
                    :data="
                      userSplitwiseDebts.userToFriends.singleUserToFriends
                        .slice()
                        .reverse()
                    "
                    :columns="debtsColumns"
                  >
                    <template #default="{ row, tdClass }">
                      <td :class="tdClass">
                        {{ row.from.first_name + ' ' + row.from.last_name }}
                      </td>
                      <td :class="tdClass">
                        {{ row.to.first_name + ' ' + row.to.last_name }}
                      </td>
                      <td :class="tdClass">${{ row.amount }}</td>
                      <td v-show="row.is_payable" :class="tdClass">
                        Pagar
                      </td>
                    </template>
                  </CustomTable>
                </div>
                <div
                  v-if="
                    userSplitwiseDebts.userToFriends.groupUserToFriends.length
                  "
                >
                  <p class="text-5xl font-bold">
                    Deudas Grupales
                  </p>
                  <div
                    v-for="(group_debt,
                    index) in userSplitwiseDebts.userToFriends.groupUserToFriends
                      .slice()
                      .reverse()"
                    :key="index"
                  >
                    <p class="text-5xl font-bold">
                      Grupo: {{ group_debt[0].group_name }}
                    </p>
                    <CustomTable :data="group_debt" :columns="debtsColumns">
                      <template #default="{ row, tdClass }">
                        <td :class="tdClass">
                          {{ row.from.first_name + ' ' + row.from.last_name }}
                        </td>
                        <td :class="tdClass">
                          {{ row.to.first_name + ' ' + row.to.last_name }}
                        </td>
                        <td :class="tdClass">${{ row.amount }}</td>
                        <td v-show="row.is_payable" :class="tdClass">
                          Pagar
                        </td>
                      </template>
                    </CustomTable>
                  </div>
                </div>
              </div>
              <div v-else>
                <p class="text-5xl font-bold">
                  No hay deudas para mostrar
                </p>
              </div>
            </div>

            <div>
              <div>
                <p class="text-5xl font-bold">
                  Deudas de amigos hacia ti
                </p>
              </div>
              <div
                v-if="
                  userSplitwiseDebts.friendsToUser.singleFriendsToUser.length ||
                  userSplitwiseDebts.friendsToUser.groupFriendsToUser.length
                "
              >
                <div
                  v-if="
                    userSplitwiseDebts.friendsToUser.singleFriendsToUser.length
                  "
                >
                  <p class="text-5xl font-bold">
                    Deudas Individuales
                  </p>
                  <CustomTable
                    :data="
                      userSplitwiseDebts.friendsToUser.singleFriendsToUser
                        .slice()
                        .reverse()
                    "
                    :columns="debtsColumns"
                  >
                    <template #default="{ row, tdClass }">
                      <td :class="tdClass">
                        {{ row.from.first_name + ' ' + row.from.last_name }}
                      </td>
                      <td :class="tdClass">
                        {{ row.to.first_name + ' ' + row.to.last_name }}
                      </td>
                      <td :class="tdClass">${{ row.amount }}</td>
                      <td v-show="row.is_payable" :class="tdClass">
                        Pagar
                      </td>
                    </template>
                  </CustomTable>
                </div>
                <div
                  v-if="
                    userSplitwiseDebts.friendsToUser.groupFriendsToUser.length
                  "
                >
                  <p class="text-5xl font-bold">
                    Deudas Grupales
                  </p>
                  <div
                    v-for="(group_debt,
                    index) in userSplitwiseDebts.friendsToUser.groupFriendsToUser
                      .slice()
                      .reverse()"
                    :key="index"
                  >
                    <p class="text-5xl font-bold">
                      Grupo: {{ group_debt[0].group_name }}
                    </p>
                    <CustomTable :data="group_debt" :columns="debtsColumns">
                      <template #default="{ row, tdClass }">
                        <td :class="tdClass">
                          {{ row.from.first_name + ' ' + row.from.last_name }}
                        </td>
                        <td :class="tdClass">
                          {{ row.to.first_name + ' ' + row.to.last_name }}
                        </td>
                        <td :class="tdClass">${{ row.amount }}</td>
                        <td v-show="row.is_payable" :class="tdClass">
                          Pagar
                        </td>
                      </template>
                    </CustomTable>
                  </div>
                </div>
              </div>
              <div v-else>
                <p class="text-5xl font-bold">
                  No hay deudas para mostrar
                </p>
              </div>
            </div>
          </div>
        </div>
        <div v-else>
          <p class="text-5xl font-bold">
            No estás conectado a Splitwise
          </p>
        </div>
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
      tableColumns: [
        'Tipo',
        'Envía',
        'Recibe',
        'Cantidad BTC',
        'Cantidad CLP',
        'Fecha',
      ],
      debtsColumns: ['De', 'Para', 'Monto', 'Pagar'],
    };
  },
  created() {
    this.getSplitwiseDebts();
    this.getPayments();
  },
  components: {
    BudaAlert,
    LinkButton,
    UserCard,
    CustomTable,
  },
  methods: {
    ...mapActions('splitwiseDebts', ['getSplitwiseDebts']),
    ...mapActions('paymentsHistory', ['getPayments']),

    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
    },
  },
  computed: {
    ...mapState('user', ['currentUser', 'getPaymentsLoading']),
    ...mapState('splitwiseDebts', [
      'getSplitwiseDebtsLoading',
      'userSplitwiseDebts',
    ]),
    ...mapState('paymentsHistory', ['userPaymentsHistory']),
    ...mapGetters('user', ['budaSignedIn', 'splitwiseSignedIn']),
  },
};
</script>

<style></style>
