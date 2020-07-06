<template>
  <div class="m-12 text-center txt-field">
    <div v-if="!budaSignedIn">
      <BudaAlert />
    </div>
    <div class="flex-col justify-start lg:flex-row p-10 rounded-md">
      <div>
        <div>
          <p class="txt-field text-xl text-black font-bold mb-10">
            Historial de transacciones
          </p>
        </div>
        <div class="justify-start">
          <div v-if="getPaymentsLoading">
            <spinner />
          </div>
          <div v-else class="text-black rounded-md">
            <div v-if="userPaymentsHistory.length">
              <CustomTable :data="userPaymentsHistory" :columns="tableColumns">
                <template #default="{ row }">
                  <div
                    v-if="
                      row.attributes.sender.email !=
                      row.attributes.receiver.email
                    "
                  >
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
                  </div>
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
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import BudaAlert from 'components/buda/BudaAlert.vue';
import CustomTable from '../components/CustomTable';
import spinner from '../components/Spinner';

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
    CustomTable,
    spinner,
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
