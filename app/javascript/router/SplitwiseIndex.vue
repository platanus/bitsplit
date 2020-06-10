<template>
  <div class="flex justify-center m-16">
    <div>
      <div>
        <label class="block text-gray-700 text-lg flex justify-center mb-5">
          Deudas de Splitwise
        </label>
      </div>
      <div v-if="splitwiseSignedIn">
        <div v-if="getSplitwiseDebtsLoading">
          <p>Cargando...</p>
        </div>
        <div v-else class="rounded-md">
          <div
            v-if="
              userSplitwiseDebts.singleDebts || userSplitwiseDebts.groupDebts
            "
          >
            <div class="p-3" v-if="userSplitwiseDebts.singleDebts">
              <label class="block text-gray-500 text-lg flex justify-left mb-3">
                Deudas Individuales
              </label>
              <CustomTable
                :data="
                  userSplitwiseDebts.singleDebts.friendsToUser
                    .concat(userSplitwiseDebts.singleDebts.userToFriends)
                    .slice()
                    .reverse()
                "
                :columns="debtsColumns"
              >
                <template #default="{ row, tdClass }">
                  <td v-if="row.type" :class="tdClass">
                    <span
                      class="text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800"
                    >
                      Te deben
                    </span>
                  </td>
                  <td v-else :class="tdClass">
                    <span
                      class="text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800"
                    >
                      Debes
                    </span>
                  </td>
                  <td :class="tdClass">
                    {{ row.first_name + ' ' + row.last_name }}
                  </td>
                  <td :class="tdClass">${{ row.amount }}</td>
                  <td v-show="row.is_payable" :class="tdClass">
                    <linkButton
                      classmod="bg-blue-500 hover:bg-blue-700 my-3 md:my-0"
                      route="splitwisepayment"
                      :payment-data="{
                        group_id: 0,
                        to_user_id: row.id,
                        first_name: row.first_name,
                        last_name: row.last_name,
                        email: row.email,
                        amount: row.amount,
                        currency_code: row.currency_code.toLowerCase(),
                      }"
                      :field-disabled="false"
                    >
                      Pagar
                    </linkButton>
                  </td>
                </template>
              </CustomTable>
            </div>
            <div class="p-3" v-if="userSplitwiseDebts.groupDebts">
              <label class="block text-gray-500 text-lg flex justify-left mb-3">
                Deudas Grupales
              </label>
              <div
                v-for="(group_debt,
                index) in userSplitwiseDebts.groupDebts.slice().reverse()"
                :key="index"
              >
                <p class="text-5xl font-bold my-3">
                  Grupo: {{ group_debt.group_name }}
                </p>
                <CustomTable
                  :data="
                    group_debt.friendsToUser
                      .concat(group_debt.userToFriends)
                      .slice()
                      .reverse()
                  "
                  :columns="debtsColumns"
                >
                  <template #default="{ row, tdClass }">
                    <td v-if="row.type" :class="tdClass">
                      <span
                        class="text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800"
                      >
                        Te deben
                      </span>
                    </td>
                    <td v-else :class="tdClass">
                      <span
                        class="text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800"
                      >
                        Debes
                      </span>
                    </td>
                    <td :class="tdClass">
                      {{ row.first_name + ' ' + row.last_name }}
                    </td>
                    <td :class="tdClass">${{ row.amount }}</td>
                    <td v-show="row.is_payable" :class="tdClass">
                      <linkButton
                        classmod="bg-blue-500 hover:bg-blue-700 my-3 md:my-0"
                        route="splitwisepayment"
                        :payment-data="{
                          group_id: group_debt.group_id,
                          to_user_id: row.id,
                          first_name: row.first_name,
                          last_name: row.last_name,
                          email: row.email,
                          amount: row.amount,
                          currency_code: row.currency_code.toLowerCase(),
                        }"
                        :field-disabled="false"
                      >
                        Pagar
                      </linkButton>
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
      <div v-else>
        <p class="text-5xl font-bold">
          No estás conectado a Splitwise
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import linkButton from '../components/LinkButton';
import CustomTable from '../components/CustomTable';

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home',
      debtsColumns: ['', 'Nombre', 'Monto', 'Pagar'],
    };
  },
  created() {
    this.getSplitwiseDebts();
  },
  components: {
    linkButton,
    CustomTable,
  },
  methods: {
    ...mapActions('splitwiseDebts', ['getSplitwiseDebts']),

    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
    },
  },
  computed: {
    ...mapState('user', ['currentUser']),
    ...mapState('splitwiseDebts', [
      'getSplitwiseDebtsLoading',
      'userSplitwiseDebts',
    ]),
    ...mapGetters('user', ['splitwiseSignedIn']),
  },
};
</script>

<style></style>
