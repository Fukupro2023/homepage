import dayjs from "dayjs";
import { Icon } from "@iconify/react";
import { PATH } from "@/constants";
import type { BlogItem } from "@/types";
import DefaultImage from "@/assets/images/default-image.jpeg";

type Props = {
  blog: BlogItem;
};

export default function BlogCard({ blog }: Props) {
  return (
    <div className="bg-white p-4 rounded-md md:block flex justify-between flex-row-reverse border shadow-md">
      <img
        src={blog.thumbnail ?? DefaultImage.src}
        alt={blog.title}
        className="object-cover w-40 h-40 flex-shrink-0 md:w-80 md:h-40"
      />
      <div>
        <p className="text-sm text-gray-500">
          {dayjs(blog.published_at).format("YYYY-MM-DD")}
        </p>
        <a href={blog.link} target="_blank" rel="noopener noreferrer">
          <h3 className="text-lg text-gray-800 font-bold line-clamp-3 hover:underline">
            {blog.title}
          </h3>
        </a>
        <div className="mt-2 flex flex-wrap gap-2">
          {blog.tags.map((tag) => (
            <a
              key={tag.id ?? tag.name}
              href={`${PATH.BLOGS}?q=tag:${encodeURIComponent(tag.name)}`}
              className="flex items-center"
            >
              <Icon icon="ri:hashtag" />
              <span className="text-sm text-gray-500">{tag.name}</span>
            </a>
          ))}
        </div>
      </div>
    </div>
  );
}
