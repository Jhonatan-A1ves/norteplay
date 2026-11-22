export default function HomePage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-4xl flex-col justify-center px-6 py-16">
      <p className="mb-3 text-sm font-semibold tracking-[0.2em] text-cyan-300">
        NORTE PLAY
      </p>
      <h1 className="text-4xl font-bold tracking-tight sm:text-5xl">
        CS2 Server Manager
      </h1>
      <p className="mt-5 max-w-2xl text-lg leading-8 text-slate-300">
        Fundação técnica em preparação. Nenhum servidor ou dado operacional foi
        conectado ainda.
      </p>
      <section
        aria-labelledby="status-title"
        className="mt-10 rounded-xl border border-slate-700 bg-slate-900/60 p-6"
      >
        <h2 id="status-title" className="text-lg font-semibold">
          Estado da plataforma
        </h2>
        <p className="mt-2 text-slate-300">
          A interface está inicializada. Autenticação e operações de servidor
          serão habilitadas em etapas futuras.
        </p>
      </section>
    </main>
  );
}
