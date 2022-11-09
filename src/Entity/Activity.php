<?php

declare(strict_types=1);

namespace App\Entity;

use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\GetCollection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Symfony\Component\Validator\Constraints\NotBlank;

#[ApiResource(operations: [new GetCollection()])]
#[Entity]
class Activity
{
    #[Id, Column, GeneratedValue]
    public ?int $id = null;

    #[Column, NotBlank]
    public string $name = '';

    #[Column(precision: 8, scale: 6), NotBlank]
    public float $lat = 0.0;

    #[Column(precision: 8, scale: 6), NotBlank]
    public float $lng = 0.0;

    #[Column(type: Types::TEXT), NotBlank]
    public string $description = '';
}
