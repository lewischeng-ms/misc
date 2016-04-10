using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODataLib
{
    public class ODataMessageWriter
    {
        private ODataRequestContext context;

        // context can be injected by DI
        public ODataMessageWriter(ODataRequestContext context)
        {
            this.context = context;
        }

        public void Write()
        {
            // Can be simplified using extension methods to IServiceProvider.
            var validator = (ODataWriterValidator) context.ServiceProvider.GetService(typeof (ODataWriterValidator));
            validator.Validate();
        }
    }
}
