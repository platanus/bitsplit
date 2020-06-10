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
          <submitButton>
            <router-link class="px-6" to="/payment">
              Hacer un pago
            </router-link>
          </submitButton>
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
                <linkButton
                  classmod="bg-blue-500 hover:bg-blue-700 my-3 md:my-0"
                  :field-disabled="false"
                  route="payments-history"
                >
                  Ver más
                </linkButton>
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
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import BudaAlert from 'components/BudaAlert.vue';
import submitButton from '../components/SubmitButton';
import linkButton from '../components/LinkButton';
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
    };
  },
  created() {
    this.getPayments();
  },
  components: {
    BudaAlert,
    submitButton,
    linkButton,
    UserCard,
    CustomTable,
  },
  methods: {
    ...mapActions('paymentsHistory', ['getPayments']),

    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
    },
  },
  computed: {
    ...mapState('user', ['currentUser', 'getPaymentsLoading']),
    ...mapState('paymentsHistory', ['userPaymentsHistory']),
    ...mapGetters('user', ['budaSignedIn', 'splitwiseSignedIn']),
  },
};
</script>

<style></style>
