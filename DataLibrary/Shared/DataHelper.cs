using System.Data;
using System.Reflection;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace TestSolution.Shared;

public class DataHelper(IConfiguration configuration)
{
    public SqlConnection GetConnection()
    {
        var connection = new SqlConnection(configuration.GetConnectionString("Dev"));
        connection.Open();
        return connection;
    }

    public DataTable ConvertObjectToDataTable<T>(T item)
    {
        var items = new List<T> { item };
        var dt = ToDataTable(items);
        return dt;
    }

    private static DataTable ToDataTable<T>(List<T> items)
    {
        var dataTable = new DataTable(typeof(T).Name);
        var props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
        foreach (var prop in props) dataTable.Columns.Add(prop.Name);
        foreach (var item in items)
        {
            var values = new object[props.Length];
            for (var i = 0; i < props.Length; i++) values[i] = props[i].GetValue(item, null)!;
            dataTable.Rows.Add(values);
        }

        return dataTable;
    }
}