json.data do
   json.balance do
      json.buda do 
         json.CLP @balance_buda_clp
         json.BTC @balance_buda_btc
         json.BTC_CLP @buda_btc_clp
      end
      json.bitsplit do 
         json.BTC @balance_bitsplit_btc
         json.BTC_CLP @balance_bitsplit_btc_clp
      end
   end
end

