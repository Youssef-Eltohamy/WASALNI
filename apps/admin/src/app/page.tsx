export default function Home() {
  return (
    <div className="flex flex-col flex-1 items-center justify-center bg-zinc-50 dark:bg-black">
      <main className="flex flex-col items-center gap-4 text-center">
        <div className="size-20 rounded-full bg-teal-600 flex items-center justify-center text-white text-3xl">
          و
        </div>
        <h1 className="text-4xl font-bold text-zinc-900 dark:text-zinc-50">
          لوحة تحكم وصلني
        </h1>
        <p className="text-lg text-zinc-600 dark:text-zinc-400">
          منصة الاكتشاف المحلي
        </p>
      </main>
    </div>
  );
}
