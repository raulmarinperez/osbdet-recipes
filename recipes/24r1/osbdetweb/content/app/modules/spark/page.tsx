import CurrentPath from '@/app/path'
import Image from 'next/image';

export default function Spark() {
    return (
        <main className="z-40 relative">  
            <div className="container px-5 py-5 mx-auto">
                <div className="grid grid-cols-2 gap-1">
                    <div className="col-start-1 col-span-1">
                        <CurrentPath current_path="Spark"/>
                    </div>
                    <div className="text-right col-start-2 col-span-1">
                        <p>Adios</p>
                    </div>
                </div>
            </div>             
            <div className=" container flex justify-between px-4 mx-auto gap-x-2 ">
                <article className="w-full px-4 rounded-lg mx-auto format format-sm sm:format-base lg:format-lg format-blue dark:format-invert">
                    <div className="relative pt-0">
                        <div className="max-w-8xl mx-auto">        
                            <h2 className=" mb-0 lg:mb-6 font-sans text-lg lg:text-3xl text-center lg:text-left font-bold leading-none tracking-tight text-gray-900   md:mx-auto">
                                <span className="relative inline-block">
                                    <span className="relative text-xl lg:text-3xl text-center ">Apache Spark 3.5</span>
                                    <img className="mt-5" src="/images/spark_banner.png"/>
                                </span>
                            </h2>
                        </div>
                        <p className="pt-4 pb-4">
                            <strong className="text-lg">How to start it up: </strong>You don&apos;t have to, Spark is a framework used when you run your 
                            notebook or application.
                        </p>
	                    <p className="pb-4"><strong className="text-lg">How to shut it down: </strong>You don&apos;t have to, resources used by Spark are released when 
                          your notebook or application is done.</p>
	                    <p className="pb-4"><strong className="text-lg">How to access: </strong>
                            <ul className="ml-8 mt-2 list-disc">
                                <li><em><strong>Spark Web UI -</strong></em> accessible via <a href="http://localhost:24040" className="underline" target="_blank">http://localhost:24040</a></li>
                            </ul>
                        </p>
	                    <p className="pb-4"><strong className="text-lg">Description: </strong>Apache Spark™ is a multi-language engine for executing data engineering, 
                          data science, and machine learning on single-node machines or clusters.</p>
                        <p className="pb-4"><strong className="text-lg">Project website: </strong> <a href="https://spark.apache.org/" className="underline" target="_blank">https://spark.apache.org/</a></p>
                        <p className="pb-4 ">
                          <strong className="text-lg">Additional notes:</strong><br/>
                          The Spark deployment available in this environment is configured in <em>Standalone Cluster Mode</em>, which 
                          means only one node will be used for jobs execution. It&apos;s highly suggested to work with small datasets (up 
                          to some hundreds of Megabytes) to avoid hitting the limits. All the main libraries available in Spark have 
                          been successfully used:
                          <ul className="ml-8 mt-2 list-disc">
                            <li><a href="https://spark.apache.org/docs/latest/streaming-programming-guide.html" target="_blank">Spark Streaming</a></li>
                            <li><a href="https://graphframes.github.io/graphframes/docs/_site/index.html" target="_blank">Spark GraphFrames</a></li>
                            <li><a href="https://spark.apache.org/mllib/" target="_blank">Spark MLlib</a></li>
                          </ul>
                        </p>
                    </div>
                </article>
            </div>
        </main>
    )
}