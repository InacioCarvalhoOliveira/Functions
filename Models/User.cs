using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Functions.Models
{

    public class User
    {
        public string Username { get; set; }
        public string Role { get; set; }
        //public string Id { get; set; }

        
    }
}