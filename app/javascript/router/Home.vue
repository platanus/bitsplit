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
        <UserCard
          :email="currentUser.email"
          :clp_balance="userBudaBalance.CLP"
          :btc_balance="userBudaBalance.BTC"
          classmod="self-center"
        />
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
          <p class="text-5xl font-bold">
            Historial de Pagos
          </p>
        </div>
        <div class="justify-start">
          <div v-if="getPaymentsLoading">
            <p>Cargando...</p>
          </div>
          <div v-else class="bg-gray-200 rounded-md">
            <div v-if="userPaymentsHistory.length">
              <CustomTable
                :data="userPaymentsHistory.slice().reverse()"
                :columns="tableColumns"
              >
                <template slot-scope="{ row }">
                  <td v-if="row.attributes.sender_email != currentUser.email">
                    <span>
                      Recibido
                    </span>
                  </td>
                  <td v-else>
                    <span>
                      Enviado
                    </span>
                  </td>
                  <td>
                    {{ row.attributes.sender_email }}
                  </td>
                  <td>
                    {{ row.attributes.receiver_email }}
                  </td>
                  <td>{{ row.attributes.amount }} BTC</td>
                  <td>
                    {{ getDate(row.attributes.created_at) }}
                  </td>
                </template>
              </CustomTable>
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
        <div>
          <div v-if="getSplitwiseDebtsLoading">
            <p>Cargando...</p>
          </div>

          <div v-else class="bg-gray-200 rounded-md">
            <div>
              <div
                v-if="
                  userSplitwiseDebts.user_to_friends.single_user_to_friends
                    .length ||
                  userSplitwiseDebts.user_to_friends.group_user_to_friends
                    .length
                "
              >
                <div
                  v-if="
                    userSplitwiseDebts.user_to_friends.single_user_to_friends
                      .length
                  "
                >
                  <p class="text-5xl font-bold">
                    Deudas Individuales
                  </p>
                  <CustomTable
                    :data="
                      userSplitwiseDebts.user_to_friends.single_user_to_friends
                        .slice()
                        .reverse()
                    "
                    :columns="debtsColumns"
                  >
                    <template slot-scope="{ row }">
                      <td>
                        {{ row.from.first_name + ' ' + row.from.last_name }}
                      </td>
                      <td>
                        {{ row.to.first_name + ' ' + row.to.last_name }}
                      </td>
                      <td>${{ row.amount }}</td>
                      <td>
                        {{ row.group_name }}
                      </td>
                      <td v-show="row.is_payable">
                        Pagar
                      </td>
                    </template>
                  </CustomTable>
                </div>
                <div
                  v-if="
                    userSplitwiseDebts.user_to_friends.group_user_to_friends
                      .length
                  "
                >
                  <p class="text-5xl font-bold">
                    Deudas Grupales
                  </p>
                  <div
                    v-for="(group_debt,
                    index) in userSplitwiseDebts.user_to_friends.group_user_to_friends
                      .slice()
                      .reverse()"
                    :key="index"
                  >
                    <p class="text-5xl font-bold">
                      Grupo: {{ group_debt[0].group_name }}
                    </p>
                    <CustomTable :data="group_debt" :columns="debtsColumns">
                      <template slot-scope="{ row }">
                        <td>
                          {{ row.from.first_name + ' ' + row.from.last_name }}
                        </td>
                        <td>
                          {{ row.to.first_name + ' ' + row.to.last_name }}
                        </td>
                        <td>${{ row.amount }}</td>
                        <td>
                          {{ row.group_name }}
                        </td>
                        <td v-show="row.is_payable">
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
    this.getSplitwiseDebts();
    if (this.budaSignedIn) {
      this.getUserBudaBalance();
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
    ...mapActions('user', [
      'getUserBudaBalance',
      'getPayments',
      'getSplitwiseDebts',
    ]),
    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
    },
  },
  computed: {
    ...mapState('user', [
      'currentUser',
      'getBalanceLoading',
      'userBudaBalance',
      'getPaymentsLoading',
      'userPaymentsHistory',
      'getSplitwiseDebtsLoading',
      'userSplitwiseDebts',
    ]),
    ...mapGetters('user', ['budaSignedIn']),
  },
};
</script>

<style></style>
