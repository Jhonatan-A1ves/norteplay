import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "NORTE PLAY | CS2 Server Manager",
  description:
    "Fundação da plataforma NORTE PLAY para gestão segura de servidores CS2.",
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
