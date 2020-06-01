json.data do
   json.balance do
      json.buda do 
         json.CLP @balance_buda_clp
         json.BTC @balance_buda_btc
      end
      json.bitsplit do 
         json.BTC @balance_bitsplit_btc
      end
   end
end


