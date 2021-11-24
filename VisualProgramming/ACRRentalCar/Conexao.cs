using System;
using System.Collections.Generic;
using System.Text;

//Definição dos nomespaces usados no projeto para o SQL Server
using System.Data;
using System.Data.SqlClient;

namespace ACRRentalCar
{
    public class Conexao
    {
        //Método para realizar a conexão com o banco de dados
        public static SqlConnection getConnection()
        {
            //cria um objeto (varíavel cnn) do tipo SqlConnection
            //e configura a string de conexao
            SqlConnection cnn = new SqlConnection(@"Data Source=.\SQLEXPRESS;Initial Catalog=DB_RENTALCAR;Integrated Security=True;Pooling=False");
            
            //Retorna uma conexão com o banco de dados quando esse método for chamado.
            return cnn;
        }
    }
}
