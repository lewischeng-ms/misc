using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WebApi;

namespace Restier
{
    public class RestierController : ODataController
    {
        // Can get a scoped container from ODataController

        public ApiBase Api
        {
            get { return (ApiBase)this.Container.GetService(typeof (ApiBase)); }
        }
    }
}
